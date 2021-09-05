interface Sprite {
  /**
   * Call Once When you Want To Resize The Sprite
   */
  SetScale(newWidth: number, newHeight: number): void;
  /**
   * Call Once When you Want To Change The Sprite Mask
   */
  SetMask(p_min: Vector, p_max: Vector): void;
  /**
   * Call Once When you Want To Recolor The Sprite
   */
  SetColor(rgba: number): void;
  /**
   * Call on OnDraw
   */
  Draw(screenPos: Vector, radius?: number | null, centered?: boolean): void;
  /**
   * Call Once When you Want To Create A New Sprite From Mask
   */
  NewFromMask(p_min: Vector, p_max: Vector): void;
}
