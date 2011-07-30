<html>
    <head>
{#include:common/header.tpl#}
        <script type="text/javascript">
            function checkValue()
            {
                var id = document.getElementById("user_name").value;
                var screen = document.getElementById("screen_name").value;
                var pass = document.getElementById("password").value;
                var veri = document.getElementById("password_verify").value;
                var capt = document.getElementById("captcha").value;
                document.getElementById("signup").disabled = id == "" || screen == "" || capt == "" || pass == "" || pass != veri;
            }
        </script>
    </head>
    <body>
        <div class="box" style="margin:3em auto;">
            新しいアカウント
            <div class="box">
                <form method="post" action="/signup/">
                    <div class="title">
                        アカウント情報
                    </div>
                    <div class="box inner">
                        ユーザーID: 
                        <input id="user_name" type="text" name="user_name" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                        表示名: 
                        <input id="screen_name" type="text" name="screen_name" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                        パスワード: 
                        <input id="password" type="password" name="password" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                        確認: 
                        <input id="password_verify" type="password" name="password-verify" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                    </div>
                    <div class="title">
                        画像認証
                    </div>
                    <div class="box inner" style="text-align:center;">
                        <img src="{#captcha_img#}"><br>
                        <input id="captcha" type="text" name="captcha" onkeyup="checkValue()" onchange="checkValue()">
                        <input id="digest" type="hidden" name="digest" value="{#captcha_digest#}">
                    </div>
                    <p><span id="error" class="error">{#error#}</span></p>
                    <input style="margin:1em 0;" id="signup" type="submit" name="send" value="登録" disabled="disabled"><br>
                </form>
            </div>
        </div>
    </body>
</html>

