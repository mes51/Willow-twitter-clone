<html>
    <head>
{#include:common/header.tpl#}
    </head>
    <body>
        <div class="outer_box">
            <div class="willow_box">
{#include:common/willow.tpl#}
            </div>
            <div class="bottom_box">
                <form method="post" action="/login/">
                    <span>ユーザーid</span><br>
                    <input id="user_name" type="text" name="user_name" maxlength="16"><br>
                    <span>パスワード</span><br>
                    <input id="password" type="password" name="password" maxlength="16"><br>
                    <input style="margin:0.2em 0;" type="submit" name="login" value="ログイン"><br>
                    <span class="error">{#error#}</span><br>
                    <a href="/signup/">アカウントを作る</a>
                </form>
            </div>
        </div>
    </body>
</html>
