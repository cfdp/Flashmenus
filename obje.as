/*

if you like this then feel free to visit the below link to purchase some high quality flash stock :)
http://flashden.net/user/MBMedia?ref=MBMedia

*/

bar.scaleX = 0;
_txt.text = "0%";

var _loaderInfo: LoaderInfo = (parent as MovieClip).loaderInfo;

// visible stays false until it's told what loader info to watch
// mouseEnabled and mouseChildren just stay false;
//visible = false;
mouseEnabled = false;
mouseChildren = false;

// stop the parent clip
(parent as MovieClip).stop();

_loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
_loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgress);

// calls when the load is done
function loaderComplete(event: Event) : void
{
	_txt.text = "100%";
	destroyLoaderInfoMirror();
	
	addEventListener(Event.ENTER_FRAME, fadeOut);
	
	(parent as MovieClip).play();
}

// calls every time progress is updated
function loaderProgress(event: ProgressEvent) : void
{
	var pct: int = event.bytesLoaded / event.bytesTotal * 100;
	if (pct < 1) pct = 1; if (pct > 100) pct = 100;
	
	bar.gotoAndStop(pct);
	
	_txt.text = pct.toString() + "%";
	
	// safety so the bar never gets wierd contortions to it
	if (bar.scaleX > 1)
		bar.scaleX = 1;
	if (bar.scaleX < 0)
		bar.scaleX = 0;
}

// this will destroy the current loaderInfo mirror that it's watching
function destroyLoaderInfoMirror() : void
{
	if (_loaderInfo == null)
		return void;
	
	_loaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
	_loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgress);
}

function fadeOut(event: Event) : void
{
	alpha -= alpha / 5;
	
	if (alpha < .01)
	{
		removeEventListener(Event.ENTER_FRAME, fadeOut);
		
		try
		{
			if (parent && parent.contains(this))
				parent.removeChild(this);
		}
		catch(e: Error)
		{
			visible = false;
		}
	}
}