	import mx.graphics.Stroke;
	import mx.charts.LegendItem;
	import mx.effects.Fade;
	import mx.events.CollectionEvent;
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	
	/**
	 * dataProvider for the map
	 **/
	 
	[Bindable] public var dataProvider:ListCollectionView = new ArrayCollection;
	
	/**
	 * coords field for the map dataProvider, default value = "coords"
	 **/
	 
	[Bindable] public var coordsField:String = "coords";
	
	/**
	 * gid field for the map dataProvider, default value = "gid"
	 **/
	 
	[Bindable] public var gidField:String = "gid";
	
	/**
	 * scale for the map, default value = 1
	 **/
	 
	[Bindable] public var scale:Number = 1;
	
	/**
	 * creationCompleteHandler()
	 * add event listeners and refresh map on creation complete
	 **/
	 
	private function creationCompleteHandler():void {				
		this.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProviderChangeHandler);
			
		this.refresh();
	}
	
	/**
	 * dataProviderChangeHandler()
	 * refresh map on change of dataProvider
	 **/
	 
	private function dataProviderChangeHandler(event:CollectionEvent):void {
		this.refresh();
	}
	
	/**
	 * refresh()
	 * redraws the map polygons as per contents of dataProvider
	 **/ 
	
	public function refresh():void {
		polygonContainer.removeAllChildren();
		
		var currentPolygonDataProvider:Object;
		
		for each( currentPolygonDataProvider in this.dataProvider ) {
			var currentPolygon:Polygon = new Polygon;
			
			currentPolygon.dataProvider = currentPolygonDataProvider;
			currentPolygon.coordsField = this.coordsField;
			currentPolygon.gidField = this.gidField;
			currentPolygon.scale = this.scale;
			
			currentPolygon.addEventListener(MouseEvent.CLICK, polygonMouseClickHandler);
			currentPolygon.addEventListener(MouseEvent.MOUSE_OVER, polygonMouseOverHandler);
			currentPolygon.addEventListener(MouseEvent.MOUSE_OUT, polygonMouseOutHandler);
			
			currentPolygon.alpha = 0.75;
			
			currentPolygon.refresh();
			
			polygonContainer.addChild(currentPolygon);
		}
	}
	
	/**
	 * polygonMouseClickHandler()
	 * 
	 **/
	
	private function polygonMouseClickHandler( event:MouseEvent ):void {
		;
	} 
	
	/**
	 * polygonMouseOverHandler()
	 * 
	 **/
	
	private function polygonMouseOverHandler( event:MouseEvent ):void {
		Polygon(event.currentTarget).alpha = 1;
	} 
	
	/**
	 * polygonMouseOutHandler()
	 * 
	 **/
	
	private function polygonMouseOutHandler( event:MouseEvent ):void {
		Polygon(event.currentTarget).alpha = 0.75;
	}
	
	/**
	 * getPolygonByGid()
	 * returns polygon by GID
	 **/
	
	public function getPolygonByGid( gid:String ):Polygon {
		return Polygon( polygonContainer.getChildByName( gid ) );
	}
	
	/**
	 * getAllPolygons()
	 * returns all polygons in array
	 **/
	
	public function getAllPolygons():Array {
		return polygonContainer.getChildren();
	}