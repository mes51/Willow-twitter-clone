<html>
    <head>
{#include:common/header.tpl#}
        <script type="text/javascript">
            function checkWillow() {
                var maxLength = 22;

                var text = document.getElementById("willow").value;
                var split = text.split("\n");
                var length = text.replace(/\n/g, "").length;
                var error = "";

                if (split.length != 3) {
                    error = "行が足りません";
                } else if (length > maxLength) {
                    error = "文字数が制限を超えています";
                }

                document.getElementById("status").innerHTML = length + " 文字 あと " + (maxLength - length) + "文字 <span class=\"error\">" + error + "</span>";
                document.getElementById("post").disabled = error.length > 0;
            }
        </script>
    </head>
    <body>
        <div style="margin:3em auto;width:100px;">
            <form method="post" action="/post/post_willow/">
                <textarea id="willow" name="willow" cols="20" rows="4" onkeyup="checkWillow()" onchange="checkWillow()"></textarea><br>
                <span id="status">
                    <script type="text/javascript">
                        checkWillow();
                    </script>
                </span><br>
                <input id="post" name="post" type="submit" value="投稿" disabled="disabled"/>
                <input id="token" name="token" type="hidden" value="{#token#}" />
            </form>
        </div>
    </body>
</html>
