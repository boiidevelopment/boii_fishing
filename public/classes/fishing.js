class Fishing {
    constructor() {
        this.baits = [];
        this.current_bait = null;
        this.build();
    }

    build() {
        this.render_bait_options();
        const content = `
            <div class="fishing_ui">
                <div class="bait">
                    <img id="bait_image" src="" alt="Bait Image">
                </div>
                <div class="message">
                    <p id="bait_status">No Bait Equipped</p>
                    <p id="action_status">Press E to equip bait</p>
                </div>
            </div>
            <div id="bait_selection">
                <h3>Select a Bait</h3>
                <div class="bait_list" id="bait_list"></div>
                <p class="close_baits">Press ESC to close</p>
            </div>
        `;

        $('#main_container').html(content);
        this.update_ui();
        this.add_listeners();
        this.render_bait_options();
    }

    async fetch_baits() {
        try {
            const response = await fetch(`https://${GetParentResourceName()}/fetch_baits`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
            });
            const data = await response.json();
            if (data.baits) {
                this.baits = data.baits;
                this.render_bait_options();
            }
        } catch (error) {
            console.error('Error fetching baits:', error);
        }
    }
    
    render_bait_options() {
        const bait_options = Object.values(this.baits).map(bait => `
            <div class="bait_selection ${bait.quantity <= 0 ? 'disabled' : ''}" 
                 data-bait="${bait.id}" 
                 style="pointer-events: ${bait.quantity <= 0 ? 'none' : 'auto'};">
                <img class="bait_image" src="assets/images/${bait.image}" alt="${bait.label}">
                <div style="display: flex; width: 90%; justify-content: space-between;">
                    <p>${bait.label}</p>
                    <p>${bait.quantity}x</p>
                </div>
            </div>
        `).join('');
        $('#bait_list').html(bait_options);
    }

    update_ui() {
        if (this.current_bait) {
            $('#bait_image').attr('src', 'assets/images/' + this.current_bait.image);
            $('#bait_status').html(`
                <div style="display: flex; justify-content: space-between; width: 100%;">
                    <span>${this.current_bait.label}</span>
                    <span id="bait_quantity">${this.current_bait.quantity}x</span>
                </div>
            `);
            $('#action_status').text('Press F to fish or E to change bait');
        } else {
            $('#bait_image').attr('src', 'assets/images/no_bait.png');
            $('#bait_status').text('No Bait Equipped');
            $('#action_status').text('Press E to equip bait');
        }
    }

    update_bait_quantity(amount) {
        if (amount === 0) {
            $('#bait_image').attr('src', 'assets/images/no_bait.png');
            $('#bait_status').text('No Bait Equipped');
            $('#action_status').text('Press E to equip bait');
        } else {
            $('#bait_quantity').text(amount + 'x');
        }
    }
    
    add_listeners() {
        $(document).on('click', '.bait_selection', (e) => {
            const selected_bait = this.baits[$(e.currentTarget).data('bait')];
            this.equip_bait(selected_bait);
            $('#bait_selection').hide();
            $.post(`https://${GetParentResourceName()}/set_bait`, JSON.stringify({ bait: selected_bait.id }));
        });

        $(document).on('click', '.close_baits', (e) => {
            $('#bait_selection').hide();
            $.post(`https://${GetParentResourceName()}/close_ui`, JSON.stringify({}));
        });

        $(document).keyup((e) => {
            if (e.key === "Escape") {
                if ($('#bait_selection').is(':visible')) {
                    this.hide_bait_ui();
                    $.post(`https://${GetParentResourceName()}/close_ui`, JSON.stringify({}));
                }
            }
        });
    }

    show_bait_ui() {
        this.fetch_baits();
        $('#bait_selection').fadeIn(500);
    }

    equip_bait(bait) {
        this.current_bait = bait;
        this.update_ui();
    }

    adjust_bait_quantity(bait_id, amount) {
        if (this.baits[bait_id]) {
            this.baits[bait_id].quantity = Math.max(0, this.baits[bait_id].quantity + amount);
            if (this.current_bait && this.current_bait.id === bait_id) {
                this.current_bait.quantity = this.baits[bait_id].quantity;
            }
            this.render_bait_options();
            this.update_ui();
        }
    }

    hide_bait_ui() {
        $('#bait_selection').fadeOut(500);
    }

    fish_reward(fish_data) {
        const content = `
            <div class="fish_display">
                <h3><span style="display:flex; align-items: center;"><img class="fish_image" src="assets/images/${fish_data.image}" alt="${fish_data.label}"> ${fish_data.label}</span></h3>
                <div class="fish_details">
                    <p>Length: ${fish_data.length}cm</p>
                    <p>Weight: ${fish_data.weight}g</p>
                </div>
                <div class="keys_container">
                    <div class="interaction_key">
                        <span class="key"><p>G</p></span> 
                        <span class="key_label">Keep</span>
                    </div>
                    <div class="interaction_key">
                        <span class="key"><p>H</p></span> 
                        <span class="key_label">Release</span>
                    </div>
                </div>
            </div>
        `;
        $('#main_container').append(content);
        this.add_fish_listeners();
    }

    add_fish_listeners() {
        const handle_keys = (e) => {
            if ($('.fish_display').is(':visible')) {
                if (e.key === 'g') {
                    this.handle_fish_action(true);
                } else if (e.key === 'h') {
                    this.handle_fish_action(false);
                }
            }
        };
        $(document).on('keydown.fish_action', handle_keys);
    }

    handle_fish_action(keep) {
        $('.fish_display').fadeOut(500, () => {
            $(document).off('keydown.fish_action');
        });
        $.post(`https://${GetParentResourceName()}/handle_fish`, JSON.stringify({ keep: keep }));
    }

    close() {
        $('#main_container').empty();
        $.post(`https://${GetParentResourceName()}/close_ui`, JSON.stringify({}));
    }
}

const test_baits = {
    boilie: {
        id: 'boilie',
        label: 'Boilie',
        image: 'fishing_boilie.png',
        quantity: 1
    },
    worms: {
        id: 'worms',
        label: 'Worms',
        image: 'fishing_worms.png',
        quantity: 2
    },
    stickleback: {
        id: 'stickleback',
        label: 'Stickleback',
        image: 'stickleback.png',
        quantity: 3
    }
};

//const test_fishing = new Fishing(test_baits);

//test_fishing.show_bait_ui(test_baits)

/*
test_fishing.fish_reward({
    label: 'Threespine Stickleback',
    image: 'stickleback.png',
    length: 5,
    weight: 30,
    value: 3
});
*/
