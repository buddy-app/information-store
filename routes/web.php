<?php

/** @var Laravel\Lumen\Routing\Router $router */
$router->get('/_alive', function () use ($router) {
    return new \Illuminate\Http\JsonResponse(['status' => 'ok']);
});
