@extends('layout.home')
@section('content')

<?php 
function checkRemoteFile($url)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,$url);
    // don't download content
    curl_setopt($ch, CURLOPT_NOBODY, 1);
    curl_setopt($ch, CURLOPT_FAILONERROR, 1);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

    $result = curl_exec($ch);
    curl_close($ch);
    if($result !== FALSE)
    {
        return true;
    }
    else
    {
        return false;
    }
}
?>

@if(session()->has('message'))
<div class="alert alert-success">
    {{ session()->get('message') }}
</div>
@endif

<table id="movieList" class="table table-striped table-bordered responsive" style="width:100%">
    <thead>
        <tr>
            <th>Name</th>
            <th style="width: 60px">Id</th>
            <th>English Name</th>
            <th style="width: 50px">Type</th>
            <th style="width: 40px">English</th>
            <th style="width: 50px">Episodes #</th>
            <th style="width: 40px">Cover</th>
            <th style="width: 40px">Poster</th>
            <th style="width: 200px">Addition Date</th>
            <th style="width: 150px">Actions</th>
        </tr>
    </thead>
    <tbody>
@foreach ($data as $item)

        <tr>
            <td>{{$item['name']}}</td>
            <td>{{$item['id']}}</td>
            <td>{{$item['tagName']}}</td>
            <td>{{$item['movieType']==1?"Movie":"Tv"}}</td>
            <td>{!!$item['englishLink']!=null&&strlen($item['englishLink'])>3?"&#9989;":"&#10060;"!!}</td>
            <td>{{$item['movieType']==2?count($item['episodes'])." Episodes":""}}</td>
         <td>{!!$item['image']!=null&&file_exists(public_path().$item['image'])?"&#9989;":"&#10060;"!!}</td>
         <td>{!!$item['poster']!=null&&file_exists(public_path().$item['poster'])?"&#9989;":"&#10060;"!!}</td>
            <td>{{$item['addedDate']}}</td>
        <td><a target="_blank" href="{{url('/AdminPanelPinnme/edit/'.$item['id'])}}">Edit</a> ||
            <a onclick="return confirm('Do you really want to delete it?');" href="{{url('/AdminPanelPinnme/delete/'.$item['id'])}}">Delete</a> ||
            <a target="_blank" href="{{url('/AdminPanelPinnme/view/'.$item['id'])}}">View</a>
        </td>
        </tr>

@endforeach
</tbody>
</table>

<script>
$(document).ready(function() {
    $('#movieList').DataTable({
        responsive: true,
        dom: 'lBfrtip',
        buttons: [
                        {
                extend: 'excelHtml5',
                title: 'Movie List',
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4]
                }
            },
            {
                extend: 'pdfHtml5',
                title: 'Movie List',
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4]
                }
            },
     
        ],
        order: [[1,"asc"]],
    });
} );
</script>
@endsection
