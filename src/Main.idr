module Main

%foreign "javascript:lambda:(name, etype, f)=>document.getElementById(name).addEventListener(etype, f)"
prim__addEventListener : String -> String -> IO () -> PrimIO ()

addEventListener : HasIO io => String -> String -> IO () -> io ()
addEventListener name etype f = primIO (prim__addEventListener name etype (liftIO f))

%foreign "javascript:lambda:name=>document.getElementById(name).innerHTML"
prim__getInnerHTML : String -> PrimIO String

getInnerHTML : HasIO io => String -> io String 
getInnerHTML = primIO . prim__getInnerHTML

%foreign "javascript:lambda:(name, newValue)=>document.getElementById(name).innerHTML = newValue"
prim__setInnerHTML : String -> String -> PrimIO ()

setInnerHTML : HasIO io => String -> String -> io () 
setInnerHTML name value = primIO (prim__setInnerHTML name value)

modifyValue : HasIO io => String -> (String -> String) -> io () 
modifyValue name f = do 
    value <- getInnerHTML name 
    setInnerHTML name (f value) 

increaseValue : String -> String
increaseValue = show . (+1) . cast

main : IO ()
main = do 
    addEventListener "button" "click" $ do 
        modifyValue "label" increaseValue