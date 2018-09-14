---
title: Library
layout: page
---

# UCEF Technical Library
This is the technical library of resource for the UCEF platform. You will find videos, presentations, and software to view and download.

# Software

<dl>
{% for document in site.data.documents %}
  {% if document.category == "software" %}
  {% if document.team == "ucef" %}
  
  <dt>
    <a href="{{document.url}}" >
    {{document.name}} (software)</a>
  </dt>
  <dd>{{document.description}}</dd>

  {% endif %}
  {% endif %}
{% endfor %}
</dl>

# HowTo Videos
<dl>
{% for document in site.data.documents %}
  {% if document.category == "videos" %}
  {% if document.team == "ucef" %}
  
  <dt>
    <a href="{{document.url}}" >
    {{document.name}} (videos)</a>
  </dt>
  <dd>{{document.description}}</dd>

  {% endif %}
  {% endif %}
{% endfor %}
</dl>

# Presentations
<dl>
{% for document in site.data.documents %}
  {% if document.category == "presentation" %}
  {% if document.team == "ucef" %}
  
  <dt>
    <a href="{{document.url}}" >
    {{document.name}} (presentation)</a>
  </dt>
  <dd>{{document.description}}</dd>

  {% endif %}
  {% endif %}
{% endfor %}
</dl>


---
Checksums for the documents stored for this site can be found [here](checksums)

  