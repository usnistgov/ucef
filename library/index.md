---
title: Transactive Energy Library
layout: page
---
#Library

---
<h2>Transactive Energy Library</h2>
<p>The following documents provide background on Transactive Energy</p>
<section>

<a href="#video">Videos</a> || <a href="#presentation">Presentations</a> || <a href="#document">Documents</a> || <a href="#TEapproach">TE Approaches</a> || <a href="#standard">Standards</a>
<hr />

<a id="Presentation">&nbsp;</a>
<h3>TE Presentations</h3>
<dl>
{% for document in site.data.documents %}

  {% if document.category == "presentation" %}
  <dt>
    {% if document.html %}
    <a href="{{document.html}}" >
    {{document.name}} (Web Page)</a>
    {% endif %}
	
    {% if document.doc %}
    <a href="{{document.doc}}" >
    {{document.name}} (Document) </a>
    {% endif %}

    {% if document.pdf %}
    <a href="{{document.pdf}}" >
    {{document.name}} (PDF) </a>
    {% endif %}

  </dt>


  <dd>{{document.description}}</dd>

{% endif %}
{% endfor %}
</dl>

<a id="document">&nbsp;</a>
<h3>TE Documents</h3>
<dl>
{% for document in site.data.documents %}

  {% if document.category == "document" %}
  <dt>
    {% if document.html %}
    <a href="{{document.html}}" >
    {{document.name}} (Web Page)</a>
    {% endif %}

    {% if document.doc %}
    <a href="{{document.doc}}" >
    {{document.name}} (Document) </a>
    {% endif %}

    {% if document.pdf %}
    <a href="{{document.pdf}}" >
    {{document.name}} (.pdf) </a>
    {% endif %}

  </dt>


  <dd>{{document.description}}</dd>

{% endif %}
{% endfor %}
</dl>


<a id="espidev">&nbsp;</a>
<h3>TE Approaches</h3>
<dl>
{% for document in site.data.documents %}

  {% if document.category == "TEapproach" %}
  <dt>
    {% if document.html %}
    <a href="{{document.html}}" >
    {{document.name}} (Web Page)</a>
    {% endif %}

    {% if document.doc %}
    <a href="{{document.doc}}" >
    {{document.name}} (Document) </a>
    {% endif %}

    {% if document.pdf %}
    <a href="{{document.pdf}}" >
    {{document.name}} (.pdf) </a>
    {% endif %}

  </dt>


  <dd>{{document.description}}</dd>

{% endif %}
{% endfor %}
</dl>




---
Checksums for the documents stored for this site can be found [here](checksums)