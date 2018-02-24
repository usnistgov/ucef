---
title: Checksums
layout: page
---
#Checksums
<p>These are checksums of the documents hosted for this collaboration</p>
<section>

<dl>
{% for document in site.data.documents %}

  {% if document.sha512 %}
  <dt>
    <span style="font-weight:bold;color:green;">{{document.name}}</span><br/>
  </dt>
  <dd>
    <span style="">md5: {{document.md5}}</span><br/>
    <span style="">sha512: {{document.sha512}}</span>
  </dd>

{% endif %}
{% endfor %}
</dl>



