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
        <form method="post" action="/signup/">
            <p>
                <span>ユーザーid<span><br>
                <input id="user_name" type="text" name="user_name" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                <span>表示名<span><br>
                <input id="screen_name" type="text" name="screen_name" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                <span>パスワード</span><br>
                <input id="password" type="password" name="password" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
                <span>確認</span><br>
                <input id="password_verify" type="password" name="password-verify" maxlength="16" onkeyup="checkValue()" onchange="checkValue()"><br>
            </p>
            <p>
                <img src="{#captcha_img#}"><br>
                <input id="captcha" type="text" name="captcha" onkeyup="checkValue()" onchange="checkValue()">
                <input id="digest" type="hidden" name="digest" value="{#captcha_digest#}">
            </p>
            <p><span id="error" class="error">{#error#}</span></p>
            <input id="signup" type="submit" name="send" value="登録" disabled="disabled"><br>
        </form>
    </body>
</html>

