<html>
    <head>
{#include:common/header.tpl#}
        <script type="text/javascript">
            function checkValue()
            {
                var screen = document.getElementById("screen_name").value;
                var old = document.getElementById("old_password").value;
                var pass = document.getElementById("new_password").value;
                var veri = document.getElementById("new_password_verify").value;
                document.getElementById("setting").disabled = screen == "" || ((pass.length > 0 || veri.length > 0) && old.length == 0) || pass != veri;
            }
        </script>
    </head>
    <body>
        <div class="box" style="margin:3em auto;position:relative;">
            設定の変更
            <div class="box">
                <form method="post" action="/setting/change_setting/">
                    <div class="title">
                        表示名の変更
                    </div>
                    <div class="box inner">
                        表示名: 
                        <input id="screen_name" type="text" name="screen_name" maxlength="16" value="{#screen_name#}" onkeyup="checkValue()" onchange="checkValue()"><br>
                    </div>
                    <div class="title">
                        パスワードの変更
                    </div>
                    <div class="box inner">
                        古いパスワード: 
                        <input id="old_password" type="password" name="old_password" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                        新しいパスワード: 
                        <input id="new_password" type="password" name="new_password" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                        確認: 
                        <input id="new_password_verify" type="password" name="new_password_verify" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                    </div>
                    <input id="token" type="hidden" name="token" value="{#token#}">
                    <input style="margin:1em 0;" id="setting" type="submit" name="setting" value="設定の変更">
                </form>
            </div>
        </div>        
    </body>
</html>
