---
layout: post
title: 
---

<div class="twelve columns"> 
 <h1 class="content-listing-header sans">Trends</h1>
  
  <ul class="content">
    {% for post in site.posts %}
    {% if post.tags contains 'trends' %}
        <hr class="slender">
        <a href="{{ post.url }}"><h5 class="contrast">{{ post.title }}</h5></a>
        <span class="smaller">{{ post.date | date: "%B %-d, %Y" }}</span>  <br/>
   {{ post.content | strip_html | truncatewords: 50 }}
    
    {% endif %}

    {% endfor %}
  </ul></div>

