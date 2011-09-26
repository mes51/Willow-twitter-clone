<html>
    <head>
{#include:common/header.tpl#}
    </head>
    <body>
        <div class="search_outer_box">
            <div class="search_top_box">
{#include:common/search_box.tpl#}
                <div class="other_search_link">
                    {#load:other_search#}
                </div>
            </div>
            <div class="search_block">
                <div class="search_title">
                    {#search_title#}
                </div>
{#hash_array:common/search_element.tpl:search_result#}
            </div>
        </div>
    </body>
</html>
