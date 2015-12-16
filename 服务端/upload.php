<?php


$userId = $_POST["userId"]; // 获取userID
$imageName = $_FILES["file"]["name"]; // 获取图片名称
$output = array();


if ($userId) {
    if ((($_FILES["file"]["type"] == "image/png")
            || ($_FILES["file"]["type"] == "image/jpg")
            || ($_FILES["file"]["type"] == "image/jpeg"))
        && ($_FILES["file"]["size"] < 2000000))
    {
        // 判断图片格式 和 图片大小 小于2M
        if ($_FILES["file"]["error"] > 0) {
            $output = array("msg"=>$_FILES["file"]["error"]);
            exit(json_encode($output));
        }else {
            $imagePath = dirname(__FILE__) . "/upload/" . $_FILES["file"]["name"];
            move_uploaded_file($_FILES["file"]["tmp_name"], $imagePath);

            // 数据库存储
            $db = new SQLite3('sq.db');
            if ($db) {
                // 数据库链接成功
                $sqlString = "insert into main(userId,image) values ('" . $userId . "','" . $imageName . "');";
                $sqlRseult = $db->query($sqlString);
                if (!$sqlRseult) {
                    $erStr = "上传失败" . $db->lastErrorMsg();
                    $output = array("msg"=>$erStr);
                    exit(json_encode($output));
                }else {
                    // 上传成功
                    $output = array("msg"=>"上传成功");
                    exit(json_encode($output));
                }
            }else{
                $output = array("msg"=>"数据库链接失败!");
                exit(json_encode($output));
            }
        }
    }else{
        $output = array("msg"=>"图片有问题");
        exit(json_encode($output));
    }
}else {
    // 处理错误逻辑
    $output = array("msg"=>"没有传入UserId");
    exit(json_encode());
}

?>
