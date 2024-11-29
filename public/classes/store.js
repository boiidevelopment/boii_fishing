class Store {
    constructor(store_id, store_name, sale_items = [], mode = 'buy') {
        this.store_id = store_id;
        this.store_name = store_name;
        this.sale_items = sale_items;
        this.mode = mode;
        this.categories = ['all'];
        this.selected_category = 'all';
        $(document).ready(() => {
            $(document).keyup((e) => this.handle_exit(e));
            this.build();
        });
    }

    handle_exit(e) {
        if (e.key === 'Escape') {
            this.close();
        }
    }

    close() {
        $('#main_container').empty();
        $.post(`https://${GetParentResourceName()}/close_ui`, JSON.stringify({}));
    }

    build() {
        this.populate_categories();
        const content = `
            <div id="store_container">
                <div class="help_text">
                    <p>Press ESC To Close Menu</p>
                </div>
                <div id="store_header">
                    <h1>${this.store_name}</h1>
                    <div id="categories_tabs">${this.render_categories()}</div>
                </div>
                <div id="items_list_wrapper">
                    <div id="items_list">${this.render_items()}</div>
                    <div id="scroll_icon" style="display: none;"><i class="fa-solid fa-angles-down fa-beat"></i> Scroll for more...</div>
                </div>
            </div>
        `;
        $('#main_container').html(content);
        this.setup_events();
        this.check_scroll();
    }

    populate_categories() {
        Object.values(this.sale_items).forEach(item => {
            item.categories.forEach(category => {
                if (!this.categories.includes(category)) {
                    this.categories.push(category);
                }
            });
        });
        this.categories.sort();
    }
    
    render_categories() {
        return this.categories.map(category => `
            <button class="category_tab" data-category="${category}">${category}</button>
        `).join('');
    }
    
    render_items() {
        return Object.values(this.sale_items).filter(item => this.selected_category === 'all' || item.categories.includes(this.selected_category)).sort((a, b) => a.price - b.price).map(item => `
            <div class="item_row">
                <img src="assets/images/${item.image}" alt="${item.label}" />
                <div class="item_details">
                    <h3>${item.label}</h3>
                    <p>$${item.price}</p>
                </div>
                <input type="number" class="quantity_input" min="1" value="1" data-item="${item.id}">
                <button class="${this.mode === 'buy' ? 'buy_button' : 'sell_button'}" data-item="${item.id}">${this.mode === 'buy' ? 'Buy' : 'Sell'}</button>
            </div>
        `).join('');
    }
    
    setup_events() {
        const self = this;

        $('#categories_tabs').off('click').on('click', '.category_tab', function () {
            const category = $(this).data('category');
            self.selected_category = category;
            $('.category_tab').removeClass('active');
            $(this).addClass('active');
            $('#items_list').html(self.render_items());
            self.setup_transaction_events();
            self.check_scroll();
        });

        $('.category_tab[data-category="all"]').addClass('active');
        $('#items_list').html(self.render_items());
        this.setup_transaction_events();
        this.check_scroll();
    }

    setup_transaction_events() {
        const self = this;
        const button_class = this.mode === 'buy' ? '.buy_button' : '.sell_button';
        $(button_class).off('click').on('click', function () {
            const item_id = $(this).data('item');
            const quantity = $(`input[data-item="${item_id}"]`).val() || 1;
            $.post(`https://${GetParentResourceName()}/handle_store_action`, JSON.stringify({ store_id: self.store_id, item: item_id, quantity: parseInt(quantity) }));
        });
    }

    check_scroll() {
        const items_list = $('#items_list')[0];
        const scroll_icon = $('#scroll_icon');
        if (items_list.scrollHeight > items_list.clientHeight) {
            scroll_icon.show();
        } else {
            scroll_icon.hide();
        }
    }
}


const sale_items = {
    water: { id: 'water', label: 'Water', image: 'water.png', price: 3, categories: ['consumables'] },
    burger: { id: 'burger', label: 'Burger', image: 'burger.png', price: 5, categories: ['consumables'] },
    worms: { id: 'worms', label: 'Worms', image: 'fishing_worms.png', price: 5, categories: ['bait'] },
};


//const test_store = new Store('fishing_store', 'Fishing Store', sale_items, 'buy');
//const test_meat_store = new Store('meat_store', 'Meat Vendor', sale_items, 'sell');
