<?php

Route::get('/', function () {
    return View("website/main");
});

Route::get('/herewegoagain/login', 'Log@index');
Route::post('/herewegoagain/process', 'Log@process');
Route::get('/herewegoagain/out', 'Log@out');


Route::group(['prefix' => 'AdminPanelPinnme','middleware' => ['checkAdmin']], function () {
    Route::get('/', 'Dashboard@index');
    Route::get('/movielist', 'Dashboard@list');
    Route::get('/addition', 'Dashboard@AdditionPage');
    Route::post('/Movieadding/', 'Dashboard@MovieAdding');
    Route::post('/update', 'Dashboard@updating');
    Route::get('/edit/{id}', 'Dashboard@Edit');
    Route::get('/changeSuggestion', 'Dashboard@Suggestion');
    Route::post('/postSuggestion', 'Dashboard@changeSuggestion');
    Route::get('/view/{id}', 'Dashboard@View');
    Route::get('/delete/{id}', 'Dashboard@Delete');
    Route::get('/episodes', 'Dashboard@episodes');
    Route::get('/fetchepisodes/{id}', 'Dashboard@FetchEpisodes');
    Route::get('/addEpisode/{id}', 'EpisodeCrud@add');
    Route::post('/postEpisode/{id}', 'EpisodeCrud@postAdd');
    Route::post('/editEpisode/{id}', 'EpisodeCrud@postEdit');
    Route::get('/episodeview/{id}', 'EpisodeCrud@view');
    Route::get('/episodeDelete/{id}', 'EpisodeCrud@delete');
    Route::get('/episodeEdit/{id}', 'EpisodeCrud@edit');
});

Route::group(['prefix' => 'api', 'middleware' => ['validApi']], function () {
    Route::get('/movies/main','Movies@MainMovies');
    Route::get('/series/main','Movies@MainSeries');
    Route::get('/movies/{genre}/{start}/{end}','Movies@MoviesByOneGenre');
    Route::get('/series/{genre}/{start}/{end}','Movies@SeriesByOneGenre');
    Route::get('/all/{genre}/{start}/{end}','Movies@AllByOneGenre');
    Route::get('/movie/{id}','Movies@MovieById');
    Route::get('/serie/{id}','Movies@SeriesById'); //new
    Route::get('/suggestedMovie','Movies@Suggested');
    Route::get('/suggestedSeries','Movies@SuggestedSeries');
    Route::get('/genres','Movies@fetchgenres');
    Route::get('/search/{movie}', 'Movies@search');
    Route::get('/like/{id}', 'Movies@like');
    Route::get('/all', "Movies@all"); //new
});

Route::get('/player', function (Request $request) {
    return redirect('/'.$request->path());
});