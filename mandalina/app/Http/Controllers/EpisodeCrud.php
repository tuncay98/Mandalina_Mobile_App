<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Storage;

class EpisodeCrud extends Controller
{
    public function add(Request $request)
    {   
        
        return view("episodeCRUD/add")->with("id", $request->route("id"));
    }

    public function view(Request $request)
    {
        $id = $request->route("id");

        $db = DB::table('episodes')->where("id",$id)->first();
        $data = array($db, $request->root(), DB::table('movies')->where("id", $db->movieID)->value("name"));
        return view("episodeCRUD/view")->with("data", $data);
    }

    public function postAdd(Request $request)
    {
        $id = $request->route('id');
        $name = $request->input('name');
        $season = $request->input('season');
        $number = $request->input('number');
        $duration = $request->input('duration');
        $description = $request->input('description');

        if($request->hasFile('video')){
            if($request->file("video")->isValid()){
                $video = $request->file("video");
                $videoname = time() . '.' . $video->getClientOriginalExtension();
                Storage::disk('public_uploads')->put("series/videos/".$id."/".$videoname, file_get_contents($video));
            }
        }

        if($request->hasFile("cover")){
            if($request->file("cover")->isValid()){
                $cover = $request->file("cover");
                $covername = time() . '.' . $cover->getClientOriginalExtension();
                Storage::disk('public_uploads')->put("series/covers/".$id."/".$covername, file_get_contents($cover));
            }
        }

        DB::table('episodes')->insertGetId(
            ['name' => $name , 'url' => "/series/videos/".$id."/".$videoname, 'season' => $season, 'number' => $number,
            'summary' => $description, "movieID" => $id, 'isDeleted' => FALSE, 'addedDate' => date("Y-m-d h:i:s"),
            'image' => "/series/covers/".$id."/".$covername, 'airtime' => $duration]
        );


        return redirect()->back()->with("message", "Saved!");
    }

    public function delete(Request $request)
    {
        $id = $request->route("id");

        DB::table('episodes')->where("id", $id)->update(['isDeleted'=> TRUE]);

        return redirect()->back()->with("message", "Saved!");
    }

    public function edit(Request $request)
    {
        $data = DB::table('episodes')->where("id", $request->route("id"))->first();

        return view("episodeCRUD/edit")->with("data",$data);
    }

    public function postEdit(Request $request)
    {
        $id = $request->route('id');
        $name = $request->input('name');
        $season = $request->input('season');
        $number = $request->input('number');
        $duration = $request->input('duration');
        $description = $request->input('description');
        $oldcover = $request->input("oldcover");
        $oldvideo = $request->input("oldvideo");
        
        if($request->hasFile('video')){
            if($request->file("video")->isValid()){
                $video = $request->file("video");
                $videoname = time() . '.' . $video->getClientOriginalExtension();
                Storage::disk('public_uploads')->put("series/videos/".$id."/".$videoname, file_get_contents($video));
            }
        }

        if($request->hasFile("cover")){
            if($request->file("cover")->isValid()){
                $cover = $request->file("cover");
                $covername = time() . '.' . $cover->getClientOriginalExtension();
                Storage::disk('public_uploads')->put("series/covers/".$id."/".$covername, file_get_contents($cover));
            }
        }

        DB::table('episodes')
        ->where('id', $id)
        ->update(
            ['name' => $name , 'image' => isset($cover)==1?"/series/covers/".$id."/".$covername:$oldcover , 'season' => $season, 'summary' => trim($description),
            'number' => $number, 'airtime' => $duration,
            'url' => isset($video)==1?"/series/videos/".$id."/".$videoname:$oldvideo, 'isDeleted' => FALSE]
        );


        return redirect()->back()->with("message", "Saved!");
    }
}
