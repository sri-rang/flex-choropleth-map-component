	import mx.charts.LegendItem;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.collections.ListCollectionView;
	
	[Bindable] public var coordsField:String = "coords";
	[Bindable] public var gidField:String = "gid";
	[Bindable] public var indicatorField:String = "indicator";
	[Bindable] public var unitField:String = "unit";
	[Bindable] public var dataField:String = "data";
	
	[Bindable] public var mapDataProvider:ListCollectionView = new ArrayCollection;
	[Bindable] public var mapScale:Number = 0.5;
				
	[Bindable] public var dataProvider:ListCollectionView = new ArrayCollection;
	
	[Bindable] public var legendDataProvider:ListCollectionView = new ArrayCollection;
	
	private function creationCompleteHandler():void {
		mapDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, mapDataProviderCollectionChangeHandler);
		dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProviderCollectionChangeHandler);
		legendDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, legendDataProviderCollectionChangeHandler); 
		
		this.refresh();
		this.refreshLegend();
	}
	
	private function mapDataProviderCollectionChangeHandler( event:CollectionEvent ):void {
		map.refresh();
	}
	
	private function dataProviderCollectionChangeHandler( event:CollectionEvent ):void {
		this.refresh();
	}
	
	private function legendDataProviderCollectionChangeHandler( event:CollectionEvent ):void {
		this.refreshLegend();
	}
	
	private function getLegendColorByData( data:Object ):uint {
		var currentLegendString:String;
		
		for each( currentLegendString in legendDataProvider ) {
			var currentLegendSplit:Array = currentLegendString.split(",");
			var resultColor:uint = 0x000000;
			
			if( currentLegendSplit.length == 3 ) {
				if( Number(data) >= Number(currentLegendSplit[0]) && Number(data) <= Number(currentLegendSplit[1]) ) {
					resultColor = currentLegendSplit[2];
					break;
				}
			}
			else if ( currentLegendSplit.length == 2 ) {
				if( String(data) == String(currentLegendSplit[0]) ) {
					resultColor = currentLegendSplit[1];
					break;
				}
			}
		}
		
		return resultColor;
	}
	
	public function refresh():void {
		if( dataProvider.length == 0 ) {
			map.refresh();
		}
		
		var currentDataObject:Object;
		
		for each( currentDataObject in dataProvider ) {
			var relatedPolygon:Polygon = map.getPolygonByGid( currentDataObject[this.gidField] );
			relatedPolygon.backgroundColor = getLegendColorByData( currentDataObject[this.dataField] );
			relatedPolygon.refresh();
			
			relatedPolygon.relatedDataObject = currentDataObject;
			
			relatedPolygon.addEventListener(MouseEvent.MOUSE_OVER, polygonMouseOverHandler);
			relatedPolygon.addEventListener(MouseEvent.MOUSE_OUT, polygonMouseOutHandler);
			relatedPolygon.addEventListener(MouseEvent.MOUSE_MOVE, polygonMouseMoveHandler);
		}
	}
	
	private function polygonMouseOverHandler( event:MouseEvent ):void {
		if( mapToolTipsInput.selected == true ) {
			toolTipContainer.visible = true;
		}
		var toolTipTextHtmlText:String = "<b>" + Polygon(event.currentTarget).dataProvider[this.gidField] + "</b><br/><i>";
		toolTipTextHtmlText += Polygon(event.currentTarget).relatedDataObject[this.indicatorField];
		toolTipTextHtmlText += ": " + Polygon(event.currentTarget).relatedDataObject[this.dataField];
		
		if( String(Polygon(event.currentTarget).relatedDataObject[this.unitField]).length > 0 ) {
			toolTipTextHtmlText += " (" + Polygon(event.currentTarget).relatedDataObject[this.unitField] + ")</i>";
		}
		
		toolTipText.htmlText = toolTipTextHtmlText;
		
		toolTipContainer.setStyle("borderColor", Polygon(event.currentTarget).backgroundColor);
		toolTipContainer.setStyle("borderStyle", "solid");
		toolTipContainer.setStyle("borderThickness", 1);
		
		toolTipContainer.x = event.localX + 12;
		toolTipContainer.y = event.localY - 3;
	}
	
	private function polygonMouseOutHandler( event:MouseEvent ):void {
		toolTipContainer.visible = false
		toolTipText.htmlText = "";
	}
	
	private function polygonMouseMoveHandler( event:MouseEvent ):void {
		toolTipContainer.x = event.localX + 12;
		toolTipContainer.y = event.localY - 3;
	}
	
	public function refreshLegend():void {
		legend.removeAllChildren();
		var currentLegendString:String;
		
		for each( currentLegendString in legendDataProvider ) {
			var currentLegendItem:LegendItem = new LegendItem;
			var currentLegendSplit:Array = currentLegendString.split(",");
			
			if( currentLegendSplit.length == 3 ) {
				currentLegendItem.setStyle("fill", currentLegendSplit[2]);
				currentLegendItem.label = " " + currentLegendSplit[0] + "-" + currentLegendSplit[1];
			}
			else if( currentLegendSplit.length == 2 ) {
				currentLegendItem.setStyle("fill", currentLegendSplit[1]);
				currentLegendItem.label = " " + currentLegendSplit[0];
			}
			
			currentLegendItem.addEventListener(MouseEvent.MOUSE_OVER, legendItemMouseOverHandler);
			currentLegendItem.addEventListener(MouseEvent.MOUSE_OUT, legendItemMouseOutHandler);
			currentLegendItem.addEventListener(MouseEvent.CLICK, legendItemMouseClickHandler);
			
			currentLegendItem.setStyle("color", 0x000000);
			currentLegendItem.setStyle("horizontalGap", 0);
			
			legend.addChild(currentLegendItem);
		}
	}
		
	private function legendItemMouseOverHandler( event:MouseEvent ):void {
		
		if( activeLegendInput.selected == true ) {
			var currentColor:uint = uint( LegendItem(event.currentTarget).getStyle("fill") );
			var currentPolygon:Polygon;
			
			for each( currentPolygon in map.getAllPolygons() ) {
				if( currentPolygon.backgroundColor == currentColor ) {
					currentPolygon.alpha = 1;
				}
				else {
					currentPolygon.alpha = 0.15;
				}
			}
		}
		
	}
	
	private function legendItemMouseOutHandler( event:MouseEvent ):void {
		
		if( activeLegendInput.selected == true ) {
			var currentColor:uint = uint( LegendItem(event.currentTarget).getStyle("fill") );
			var currentPolygon:Polygon;
			
			for each( currentPolygon in map.getAllPolygons() ) {
				currentPolygon.alpha = 0.75;
			}
		}
	}
	
	private function legendItemMouseClickHandler( event:MouseEvent ):void {
		
		if( activeLegendInput.selected == true ) {
			var currentLegendColor:uint = LegendItem( event.currentTarget ).getStyle("color");
			var currentColor:uint;
			var currentPolygon:Polygon;
			
			if( currentLegendColor == 0x000000 ) {
				currentColor= uint( LegendItem(event.currentTarget).getStyle("fill") );
				
				for each( currentPolygon in map.getAllPolygons() ) {
					if( currentPolygon.backgroundColor == currentColor ) {
						currentPolygon.visible = false;
					}
				}
				LegendItem( event.currentTarget ).setStyle("color", 0xcccccc);
				LegendItem( event.currentTarget ).setStyle("fontWeight", "normal");
			}
			else {
				currentColor= uint( LegendItem(event.currentTarget).getStyle("fill") );
				
				for each( currentPolygon in map.getAllPolygons() ) {
					if( currentPolygon.backgroundColor == currentColor ) {
						currentPolygon.visible = true;
					}
				}
				LegendItem( event.currentTarget ).setStyle("color", 0x000000);
				LegendItem( event.currentTarget ).setStyle("fontWeight", "bold");
			}
		}
	}