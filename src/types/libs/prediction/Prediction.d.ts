/** @noSelf **/
interface Prediction {
  GetPredictedPosition(
    target: AIBaseClient,
    input: PredictionInput,
    source: Vector
  ): PredictionResult;
}
