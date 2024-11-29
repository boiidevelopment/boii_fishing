let store = null;
let prog_timer = null;
let fishing = null;

const handlers = {
    open_store: (data) => {
        store = new Store(data.data.type, data.data.name, data.data.items, data.data.mode);
    },
    start_timer: (data) => {
        prog_timer = new ProgressTimer(data.message, data.duration);
    },
    open_fishing: () => {
        fishing = new Fishing()
    },
    close_fishing: () => {
        if (fishing) {
            fishing.close();
        }
    },
    show_bait_ui: () => {
        if (fishing) {
            fishing.show_bait_ui()
        }
    },
    fish_reward: (data) => {
        if (fishing) {
            fishing.fish_reward(data.fish_data)
        }
    },
    update_bait_quantity: (data) => {
        if (fishing) {
            fishing.update_bait_quantity(data.quantity);
        }
    }
}

window.addEventListener('message', function (event) {
    const data = event.data;
    const handler = handlers[data.action];
    if (handler) {
        handler(data);
    }
});