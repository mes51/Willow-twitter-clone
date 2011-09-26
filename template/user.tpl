<html>
    <head>
{#include:common/header.tpl#}
    </head>
    <body>
        <div class="outer_box">
{#include:common/search_box.tpl#}
            <div class="old_post_link">
                {#load:old_post#}
            </div>
            <div class="willow_box">
{#include:common/willow.tpl#}
            </div>
            <div class="bottom_box">
                <div style="float:right;">
                    <a href="/follow/{#user_name#}">フォロー・フォロー解除</a>
                </div>
            </div>
        </div>
    </body>
</html>
