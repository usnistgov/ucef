---
title: Community
layout: page
---

#Community

The purpose of this page is to allow visitors and participants to see and discuss comments and issues about UCEF. 

## UCEF Github Discussions

<a href="https://github.com/usnistgov/ucef/issues/6" target="_blank">General UCEF Discussion</a>

## UCEF Technical Notes

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ site.baseurl }}/{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>