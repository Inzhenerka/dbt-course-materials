# Спойлер

Предназначен для вставки раскрываемых подсказок.

Состоит из двух HTML-блоков:

1. Служебный блок: стили и скрипт

Его достаточно вставить один раз в любом месте страницы

```html
<html>
    <head>
        <style>
            .accordion-header {
                background-color: #ebebeb;
                color: #444;
                cursor: pointer;
                padding: 15px;
                width: 100%;
                border: none;
                text-align: left;
                outline: none;
                font-size: 18px;
                transition: 0.4s;
                font-family: "Source Code Pro", "Arial", Roboto, "Open Sans",
                    sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI",
                    Oxygen, Cantarell, "Helvetica Neue";
            }

            .accordion-header:hover,
            .accordion-header.active {
                background-color: #ccc;
            }
            .accordion-content {
                padding: 0 18px;
                display: none;
                overflow: hidden;
            }
        </style>
    </head>
    <body>
        <script>
            var acc = document.getElementsByClassName("accordion-header");
            var i;

            for (i = 0; i < acc.length; i++) {
                acc[i].addEventListener("click", function () {
                    this.classList.toggle("active");
                    var content = this.nextElementSibling;
                    if (content.style.display === "block") {
                        content.style.display = "none";
                    } else {
                        content.style.display = "block";
                    }
                });
            }
        </script>
    </body>
</html>
```

2. Содержательный блок: заголовок и скрытый текст

```html
<button class="accordion-header"><p>Подсказка 1 ▼</p></button>
<div class="accordion-content">
    <p>Содержимое подсказки 1</p>
</div>

<button class="accordion-header">Подсказка 2 ▼</button>
<div class="accordion-content">
    <p>Содержимое подсказки 2</p>
</div>
```
