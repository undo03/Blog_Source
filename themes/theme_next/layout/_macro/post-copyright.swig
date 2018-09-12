<ul class="post-copyright">
  <li class="post-copyright-author">
    <strong>本文标题:&nbsp;&nbsp;</strong>
    <a href="{{ url_for(page.path) }}">{{ page.title }}</a>
  </li>
  <li class="post-copyright-author">
    <strong>{{ __('post.copyright.author') + __('symbol.colon') }}</strong>
    {{ post.author | default(config.author) }}
  </li>
  <li class="post-copyright-author">
    <strong>发布时间:&nbsp;&nbsp;</strong>
    {{ page.date.format("YYYY-MM-DD") }}
  </li>
  <li class="post-copyright-link">
    <strong>{{ __('post.copyright.link') + __('symbol.colon') }}</strong>
    <a href="{{ 'http://www.songqibin.cn' + post.url | default(post.permalink) }}" title="{{ post.title }}">{{ 'http://www.songqibin.cn' + post.url | default(post.permalink) }}</a>
  </li>
  <li class="post-copyright-license">
    <strong>{{ __('post.copyright.license_title') + __('symbol.colon') }} </strong>
    {{ __('post.copyright.license_content', theme.post_copyright.license_url, theme.post_copyright.license) }}
  </li>
</ul>
<p style="font-size:16px;font-weight:600;margin: 20px 0 0 0;">好友链接:</p>
<ul class="post-copyright" style="margin-top:10px;">
  <li class="post-copyright-author">
    <strong>ice_point：</strong>
    <a href="https://www.lishuaishuai.com/" target="_blank" title="ice_point的博客">https://www.lishuaishuai.com</a>
  </li>
  <li class="post-copyright-author">
    <strong>lenore：</strong>
    <a href="https://www.lenore412.com/" target="_blank" title="lenore的博客">https://www.lenore412.com</a>
  </li>
</ul>
