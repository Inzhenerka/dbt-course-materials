# Чат с Дуду

Сниппет предназначен для вставки кнопки и модального окна для общения с Дуду.

Настраиваемые параметры:

- `iframe src` - ссылка на Дуду для конкретного курса или задания

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    .round-button{position:fixed;bottom:20px;right:20px;width:80px;height:80px;padding:0;background-color:white;border:2px solid #494fe3;border-radius:50%;cursor:pointer;z-index:1000;box-shadow:0 0 20px 0 rgba(0,0,0,.3)}
    .round-button img{width:100%;height:100%;object-fit:cover;border-radius:50%}
    .modal-background{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background-color:rgba(0,0,0,0.5);z-index:999;overflow:auto}
    .modal-content{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);background-color:white;padding:20px;border-radius:8px;box-shadow:0 5px 15px rgba(0,0,0,0.3);width:100%;height:90%;max-width:950px;max-height:650px;display:flex;flex-direction:column}
    .close-button{background-color:#494fe3;color:white;border:none;width:100px;padding:10px 20px;margin: 10px auto 0;cursor:pointer;border-radius:5px;display:block}
    .modal-header { text-align: center; font-size: 24px; margin-bottom: 20px; }
  </style>
</head>
<body>
  <button class="round-button" id="openModalBtn">
    <img src="https://github.com/Inzhenerka/dbt-course-materials/blob/main/art/Doudou2.png?raw=true">
  </button>
  <div class="modal-background" id="modalBackground">
    <div class="modal-content">
      <h2 class="modal-header">Спроси Дуду</h2>
      <iframe src="https://pumproom.inzhenerka-cloud.com/?repo_name=dbt-Pumping&task_name=0_chat" height="450px" width="100%"></iframe>
      <button class="close-button" id="closeModalBtn">Закрыть</button>
    </div>
  </div>
  <script>
    const openModalBtn=document.getElementById('openModalBtn'),closeModalBtn=document.getElementById('closeModalBtn'),modalBackground=document.getElementById('modalBackground');openModalBtn.onclick=function(){modalBackground.style.display='block'},closeModalBtn.onclick=function(){modalBackground.style.display='none'},window.onclick=function(e){e.target===modalBackground&&(modalBackground.style.display='none')}
  </script>
</body>
</html>
```