	
	[Bindable] public var dataProvider:Object;
	
	[Bindable] public var relatedDataObject:Object;
	
	[Bindable] public var coordsField:String = "coords";
	[Bindable] public var gidField:String = "gid";
	
	[Bindable] public var scale:Number = 1;
	
	[Bindable] public var backgroundColor:uint = 0xffffff;
	[Bindable] public var backgroundAlpha:Number = 1;
		
	[Bindable] public var borderThickness:Number = 1;
	[Bindable] public var borderAlpha:Number = 0.75;
	[Bindable] public var borderColor:uint = 0x000000;
	
	private function creationCompleteHandler():void {
		this.buttonMode = true;
	}
	
	/**
	 * refresh()
	 * redraw the polygon
	 **/ 
	
	public function refresh():void {
		
		this.graphics.clear();
		
		this.graphics.lineStyle(borderThickness, borderColor, borderAlpha);
		this.graphics.beginFill(backgroundColor, backgroundAlpha);
		
		if( String(this.dataProvider[coordsField]).length > 0 ) {
			var coordsArray:Array = String(this.dataProvider[coordsField]).split("|");
			var currentCoord:String;
			var i:int = 0;
			for each( currentCoord in coordsArray ) {
				var currentX:Number = currentCoord.split(",")[0] * scale;
				var currentY:Number = currentCoord.split(",")[1] * scale;
				
				if( i++ == 0 ) {
					this.graphics.moveTo(currentX, currentY);
				}
				
				this.graphics.lineTo(currentX, currentY);
			}
		}
		
		this.name = this.dataProvider[gidField];
		
	}