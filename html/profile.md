# Профиль пользователя

Сниппет предназначен для автоматической передачи профиля пользователя в PumpRoom.
Это позволяет отслеживать идентифицировать ученика, отслеживать его действия и сохранять прогресс.


```html
<!-- Сниппет для автоматической передачи профиля пользователя в PumpRoom -->
<script>
    window.addEventListener("message", event => {
        if (event.origin.endsWith(".inzhenerka-cloud.com") && event.data?.type === "getTildaProfile") {
            event.source.postMessage(
                { type: "getTildaProfile", data: window.parent.tma__getProfileObjFromLS() }, event.origin
            );
        }
    });
</script>
```
