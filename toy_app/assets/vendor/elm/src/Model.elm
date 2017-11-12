module Model exposing (Model, new)

-- type alias
type alias Model =
  { isDebug : Bool
  , message : Maybe String
  }

-- export function
new : Model
new =
  Model
    False   -- isDebug
    Nothing -- message

