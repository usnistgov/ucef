#!/usr/bin/python 
 
import sys 
import boto.sts 
import boto.s3 
import requests 
import getpass 
import ConfigParser 
import base64 
import xml.etree.ElementTree as ET 
from bs4 import BeautifulSoup 
from os.path import expanduser 
from urlparse import urlparse, urlunparse 
from requests_ntlm import HttpNtlmAuth

import subprocess
import os

def checkAccess():
	devnull = open(os.devnull, 'w')
	# copy file up to aws s3
	cmd = 'aws --profile saml s3 ls'
	#print ('cmd = ' + cmd)

	result = subprocess.call(cmd,stdin=devnull, stdout=devnull, stderr=devnull, shell=False)
	return result

def initializeCredentials(): 
	##########################################################################
	# Variables 
	 
	# region: The default AWS region that this script will connect 
	# to for all API calls 
	region = 'us-west-2' 
	 
	# output format: The AWS CLI output format that will be configured in the 
	# saml profile (affects subsequent CLI calls) 
	outputformat = 'json'
	 
	# awsconfigfile: The file where this script will store the temp 
	# credentials under the saml profile 
	awsconfigfile = '/.aws/credentials'
	 
	# SSL certificate verification: Whether or not strict certificate 
	# verification is done, False should only be used for dev/test 
	sslverification = True 
	 
	# idpentryurl: The initial URL that starts the authentication process. 
	idpentryurl =  'https://auth.nist.gov/adfs/ls/IdpInitiatedSignOn.aspx?loginToRp=urn:amazon:webservices'
	 
	##########################################################################

	# Get the federated credentials from the user
	print "NIST Realm Username:",
	username = 'NIST\\' + raw_input()
	password = getpass.getpass()
	print ''

	# Initiate session handler 
	session = requests.Session() 
	 
	# Programatically get the SAML assertion 
	# Set up the NTLM authentication handler by using the provided credential 
	session.auth = HttpNtlmAuth(username, password, session) 
	 
	# Opens the initial AD FS URL and follows all of the HTTP302 redirects 
	response = session.get(idpentryurl, verify=sslverification) 
	 
	# Debug the response if needed 
	#print (response.text)

	# Overwrite and delete the credential variables, just for safety
	username = '##############################################'
	password = '##############################################'
	del username
	del password

	# Decode the response and extract the SAML assertion 
	soup = BeautifulSoup(response.text.decode('utf8'),"html.parser") 
	assertion = '' 
	 
	# Look for the SAMLResponse attribute of the input tag (determined by 
	# analyzing the debug print lines above) 
	for inputtag in soup.find_all('input'): 
		if(inputtag.get('name') == 'SAMLResponse'): 
			#print(inputtag.get('value')) 
			assertion = inputtag.get('value')

	# Parse the returned assertion and extract the authorized roles 
	awsroles = [] 
	root = ET.fromstring(base64.b64decode(assertion))
	 
	for saml2attribute in root.iter('{urn:oasis:names:tc:SAML:2.0:assertion}Attribute'): 
		if (saml2attribute.get('Name') == 'https://aws.amazon.com/SAML/Attributes/Role'): 
			for saml2attributevalue in saml2attribute.iter('{urn:oasis:names:tc:SAML:2.0:assertion}AttributeValue'):
				awsroles.append(saml2attributevalue.text)
	 
	# Note the format of the attribute value should be role_arn,principal_arn 
	# but lots of blogs list it as principal_arn,role_arn so let's reverse 
	# them if needed 
	for awsrole in awsroles: 
		chunks = awsrole.split(',') 
		if'saml-provider' in chunks[0]:
			newawsrole = chunks[1] + ',' + chunks[0] 
			index = awsroles.index(awsrole) 
			awsroles.insert(index, newawsrole) 
			awsroles.remove(awsrole)

	# If I have more than one role, ask the user which one they want, 
	# otherwise just proceed 
	print "" 
	if len(awsroles) > 1: 
		i = 0 
		print "Please choose the role you would like to assume:" 
		for awsrole in awsroles: 
			print '[', i, ']: ', awsrole.split(',')[0] 
			i += 1 

		print "Selection: ", 
		selectedroleindex = raw_input() 
	 
		# Basic sanity check of input 
		if int(selectedroleindex) > (len(awsroles) - 1): 
			print 'You selected an invalid role index, please try again' 
			sys.exit(0) 
	 
		role_arn = awsroles[int(selectedroleindex)].split(',')[0] 
		principal_arn = awsroles[int(selectedroleindex)].split(',')[1]
	 
	else: 
		role_arn = awsroles[0].split(',')[0] 
		principal_arn = awsroles[0].split(',')[1]

	# Use the assertion to get an AWS STS token using Assume Role with SAML
	conn = boto.sts.connect_to_region(region)
	token = conn.assume_role_with_saml(role_arn, principal_arn, assertion)

	# Write the AWS STS token into the AWS credential file
	home = expanduser("~")
	filename = home + awsconfigfile
	 
	# Read in the existing config file
	config = ConfigParser.RawConfigParser()
	config.read(filename)
	 
	# Put the credentials into a specific profile instead of clobbering
	# the default credentials
	if not config.has_section('saml'):
		config.add_section('saml')
	 
	config.set('saml', 'output', outputformat)
	config.set('saml', 'region', region)
	config.set('saml', 'aws_access_key_id', token.credentials.access_key)
	config.set('saml', 'aws_secret_access_key', token.credentials.secret_key)
	config.set('saml', 'aws_session_token', token.credentials.session_token)
	 
	# Write the updated config file
	with open(filename, 'w+') as configfile:
		config.write(configfile)

	# Give the user some basic info as to what has just happened
	print '\n\n----------------------------------------------------------------'
	print 'Your new access key pair has been stored in the AWS configuration file {0} under the saml profile.'.format(filename)
	print 'Note that it will expire at {0}.'.format(token.credentials.expiration)
	print 'After this time you may safely rerun this script to refresh your access key pair.'
	print 'To use this credential call the AWS CLI with the --profile option (e.g. aws --profile saml ec2 describe-instances).'
	print '----------------------------------------------------------------\n\n'

if (checkAccess() != 0) :
	print ("Access denied, initialize credentials")
	initializeCredentials()
else :
	print ("Access valid")
