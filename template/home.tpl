<html>
    <head>
{#include:common/header.tpl#}
    </head>
    <body>
        <p>
            {#user_name#}<br>
            {#screen_name#}<br>
            <div class="willow block">
{#hash_array:common/willow.tpl:willow#}
            </div>
            <a href="/post/">投稿</a><br>
            <a href="/logout/">ログアウト</a>
        </p>
    </body>
</html>
