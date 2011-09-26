<html>
    <head>
{#include:common/header.tpl#}
    </head>
    <body>
        <div class="box" style="margin:3em auto;position:relative;">
            <div class="box inner" style="text-align:center">
                あなたは{#screen_name#}(@{#user_name#})をフォローして{#now_following#}<br>
                {#action_message#}しますか?
                <form action="/follow/{#user_name#}" method="post">
                    <input id="token" type="hidden" name="token" value="{#token#}">
                    <input id="action" type="hidden" name="action" value="{#action#}">
                    <input style="margin:1em 0;" id="setting" type="submit" name="setting" value="{#action_message#}">
                    <a href="javascript:history.back()">戻る</a>
                </form>
            </div>
        </div>
    </body>
</html>
