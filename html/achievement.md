# Ачивка

Сниппет предназначен для вставки двухстрочных сообщений с иконкой на цветном фоне. Похоже на полоску ачивмента.

Настраиваемые параметры:

- `background-color` - цвет фона
- `src` - ссылка на изображение
- `td` - текстовые строки


```html
<table style="background-color: #fafad2; padding-right: 20px;">
  <tr>
    <td>
      <img src="https://github.com/Inzhenerka/dbt-course-materials/blob/main/art/mark_playlist.jpg?raw=true" alt="icon" style="max-width: 75px;">
    </td>
    <td style="padding-left: 10px; vertical-align: bottom; padding-bottom: 5px;"><b>Легендарный артефакт разблокирован</b><br>
    <a href="https://music.yandex.ru/users/PashokRos/playlists/1003" target="_blank">Плейлист Марка для работы (18+)</a>
    </td>
  </tr>
</table>
```
