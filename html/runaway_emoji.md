# Убегающий эмоджи

Сниппет с эмоджи 👍 и 👎, при чем второй убегает. Для развлечения.

Настраиваемые параметры:

- html-коды emoji


```html
<html>
    <head>
        <style>
            #inzh_move {
                position: relative;
            }
            .inzh_emoji_button {
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <script>
            function inzh_runaway(id) {
                id.style.top = Math.round(Math.random() * 75) + "px";
                id.style.left = Math.round(Math.random() * 150) + "px";
            }
        </script>
        <div style="min-height: 75px; min-width: 150px; font-size: 32px">
            <span class="inzh_emoji_button"> &#128077; </span>
            <span
                id="inzh_move"
                class="inzh_emoji_button"
                onmouseover="inzh_runaway(this)"
            >
                &#128078;
            </span>
        </div>
    </body>
</html>
```
