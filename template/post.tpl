<html>
    <head>
{#include:common/header.tpl#}
        <script type="text/javascript">
            function checkWillow() {
                var maxLength = 25;

                var text = document.getElementById("willow").value;
                var split = text.split("\n");
                var length = text.length;

                document.getElementById("post").disabled = split.length != 3 || length > maxLength;
                document.getElementById("status").innerHTML = "split: " + split.length + " length: " + text.length;
            }
        </script>
    </head>
    <body>
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
    </body>
</html>
