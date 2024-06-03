/* LUA connection */
window.addEventListener('message', (event) => {
    closeMenuEvent();
    
    let data = event.data;
    if (data.script === GetParentResourceName() && data.type === "ui") {
        if (data.display) {
            /* display: body */
            document.querySelector("body").style.display = "initial";
            /* reset html */
            document.querySelector(".tablette .buyMenu").style.display = "none";
            document.querySelector(".tablette .list").style.display = "flex";
        }else{
            configManagment(data.configuration);
        }
    }
})