
/**
* @author ReneÂ´Skou aka Amras 
 * 
 * updated 08-06-2008
 * 
 * loads xmldata 
 * 
 * 
*/
package utilis.xml
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

	public class Xmlloader extends EventDispatcher
	{
		public var xmlObject:XML;
        private var request:URLRequest;
        private var urlloader:URLLoader;
        // variabler kan ikke ændres men tilgåes
        public static const XMLLOADED:String = "xmldataloaded";
        public static const NOXML:String = "noxmlDataloaded";
		public static const PROGRESS:String = "progressupdate";
        
		
		// hvordan den bruges, opret et nyt objekt af klassen:
		// var xmlob:Xmlloader = new Xmlloader(url:String);
		
		public function Xmlloader(xmlfile:String):void {
            request = new URLRequest(xmlfile);
            urlloader = new URLLoader(request);
            urlloader.addEventListener(Event.COMPLETE, completeHandler);
            urlloader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlloader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        }
        
        
        //brug: xmlob.addEventListener(Xmlloader.XMLLOADED, loadedHandler);
        // og : xmlob.addEventListener(Xmlloader.NOXML, onXMLDATAHandler);
        // hvis der er xmldata i objektet fyr en XMLLOADED event af,
        // ellers fyr en NOXML event af.
        // Xmlobjektet tilgåes i loadedHandler med Xmlloader.xmlobject..parent(); f.eks.
        
        private function completeHandler(event:Event):void {
            if(urlloader.data) {
                xmlObject = new XML(urlloader.data);
                dispatchEvent(new Event(XMLLOADED));
            }else{
                dispatchEvent(new Event(NOXML));
            }
        }
		//react to a progress event
		private function progressHandler(e:Event):void
		{
			dispatchEvent(new Event(PROGRESS));
		}
        
        // Klarer en IOError event.
        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("IOErrorEvent.IO_ERROR in Xmlloader.as " + request);
        }
    }
}