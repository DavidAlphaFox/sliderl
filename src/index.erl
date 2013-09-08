-module(index).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-compile(export_all).

main() ->
	#template{file="./priv/templates/bare.html"}.

body() ->
	PerPage = 20,
	{Count, Body} = slidelist_body("", 1, PerPage),
	#paginate{
		id=slideshows,
		perpage=PerPage,
		tag=slideshows,
		body=Body,
		num_items=Count,
		perpage_options=[10,20,50,100]
	}.

slidelist_body(Search, Page, PerPage) ->
	Slideshows = slideshow:list(Search),
	Num = length(Slideshows),
	Body = [slideshow_preview_and_link(SS) || SS <- Slideshows],
	{Num, Body}.

slideshow_preview_and_link({File, FirstSlide}) ->
	Filename = filename:rootname(filename:basename(File)),
	Url = "/view/" ++ Filename,
	Click = #event{type=click, actions=#redirect{url=Url}},
	#panel{class=slideshow_wrapper, actions=Click, body=[
		#link{class=slideshow_filename, text=Filename, url=Url},
		#panel{class=slideshow_preview,body=[
			markdown:conv(wf:to_list(FirstSlide))
		]}
	]}.
