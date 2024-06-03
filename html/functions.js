/**
 * add a beautiful cosmetic for mouse cursor
 */
function followMouseEvent() {
    const tabletteDiv = document.querySelector('.tablette');
    tabletteDiv.addEventListener("mousemove", (event) => {
        let mousseFollow = document.getElementById("mousseFollow");
        if (mousseFollow === null) {
            mousseFollow = document.createElement('div');
            mousseFollow.id = "mousseFollow";
            document.querySelector("body").appendChild(mousseFollow);
            mousseFollow.style.pointerEvents = "none";
            mousseFollow.style.position = "absolute";
            mousseFollow.style.padding = "30px";
            mousseFollow.style.background = "rgba(0,0,0, .3)";
            mousseFollow.style.borderRadius = "150px";
        }
        mousseFollow.style.top = event.y - 30 + "px";
        mousseFollow.style.left = event.x - 30 + "px";
    });
}

/**
 * close UI
 * @param {number} num
 * @param {bool} boolCar
 */
function closeUI(num, boolCar) {
    document.querySelector("body").style.display = "none";

    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            closeMenu: true,
            ////////////
            number: num,
            useCar: boolCar
        })
    });
}

/**
 * close UI event
 */
function closeMenuEvent() {
    const html = document.querySelector("html");
    const body = document.querySelector("body");
    html.onclick = (event) => {
        if (event.target === html || event.target === body) {
            closeUI();
        }
    }
}

/**
 * add html elements
 * @param {table} configuration 
 */
function AddingElements(configuration) {
    /* Adding Title */
    const tabletteTitle = `${configuration.title}`;
    document.querySelector(".tablette h1").innerText = tabletteTitle;
    /* Adding items */
    let itemsList = ``;
    for (let i=0;i<configuration.items.length;i++) {
        itemsList += `
                     <div class="item ${i + 1}">
                         <h3>${configuration.items[i].title}</h3>
                         <img src="../images/${configuration.items[i].img}" alt="crate">
                         <strong>
                            <ul>
                                <li>${configuration.items[i].textReward + configuration.items[i].crateToGiveInGame.reward}</li>
                                <li>${configuration.items[i].textPrice + configuration.items[i].crateToGiveInGame.price}</li>
                            </ul>
                         </strong>
                     </div>
                     `;
    }
    document.querySelector(".tablette .list").innerHTML = itemsList;
}

/**
 * Menu
 * @param {number} caisseNumb 
 */
function getMenuForm(caisseNumb) {
    document.querySelector(".tablette .buyMenu form").addEventListener('submit', (event) => {
        event.preventDefault();

        let inputRadio = document.querySelectorAll(".tablette .buyMenu input");
        for (let i=0;i<inputRadio.length;i++) {
            if (inputRadio[i].checked) {
                closeUI(caisseNumb, parseInt(inputRadio[i].value));
                break;
            }
        }
    })
}
/**
 * Managment Menu
 * @param {table} configuration 
 */
function managmentbuyMenu(configuration) {
    const allDivItem = document.querySelectorAll(".tablette .list .item");
    let caisseNumb = null;
    for (let i=0;i<allDivItem.length;i++) {
        allDivItem[i].onclick = (event) => {
            if (event.target.classList[1] === undefined) {
                caisseNumb = event.target.offsetParent.classList[1];
            }else{
                caisseNumb = event.target.classList[1];
            }
            document.querySelector(".tablette .buyMenu").innerHTML = `
                                         <div class="item">
                                             <h3>${configuration.items[caisseNumb - 1].title}</h3>
                                             <img src="../images/${configuration.items[caisseNumb - 1].img}" alt="crate">
                                             <strong>
                                             <ul>
                                                 <li>${configuration.items[caisseNumb - 1].textReward + configuration.items[caisseNumb - 1].crateToGiveInGame.reward}</li>
                                                 <li>${configuration.items[caisseNumb - 1].textPrice + configuration.items[caisseNumb - 1].crateToGiveInGame.price}</li>
                                             </ul>
                                             </strong>
                                         </div>
                                         <div class="rentingCarMenu">
                                             <h2>${configuration.buyCrate.MenuRentingCarText}</h2>
                                             <form method="post" action=?>
                                                     <label for="rentingCarTRUE">${configuration.buyCrate.MenuRentingCarButtonAndRadioText.labelRadio[0]}</label>
                                                     <input type="radio" id="rentingCarTRUE" name="rentingCar" value="1" checked>
                                                     <label for="rentingCarFALSE">${configuration.buyCrate.MenuRentingCarButtonAndRadioText.labelRadio[1]}</label>
                                                     <input type="radio" id="rentingCarFALSE" name="rentingCar" value="0">
                                                     <button>${configuration.buyCrate.MenuRentingCarButtonAndRadioText.submit}</button>
                                             </form>
                                         </div>
                                     `;

            document.querySelector(".tablette .list").style.display = "none";
            document.querySelector(".tablette .buyMenu").style.display = "flex";

            getMenuForm(caisseNumb);
        }
    }
}

/**
 * config managment
 * @param {table} configuration 
 */
function configManagment(configuration) {
    /* Adding Elements */
    AddingElements(configuration);
    managmentbuyMenu(configuration);
}