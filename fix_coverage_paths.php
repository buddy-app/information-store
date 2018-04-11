<?php

$clover = file_get_contents('clover.xml');
$clover = preg_replace('/\/var\/www\/html\//', '/root/src/', $clover);
file_put_contents('clover.xml', $clover);