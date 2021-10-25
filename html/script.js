var app = new Vue({
    el: '#app',
    data: { 
        status: {
            armour: {
                icon: "<i class='fas fa-user-shield'>", 
                value: 0, 
                color: '#3c64ee' 
            },
            stamina: {
                icon: "<i class='fas fa-running'>", 
                value: 100, 
                color: '#cbee3c' 
            },
            stress: {
                icon: "<i class='fas fa-brain'>", 
                value: 0, 
                color: '#C77BFF'
            },
            health: {
                icon: "<i class='fas fa-heartbeat'>", 
                value: 0, 
                color: '#f06a49' 
            },
            hunger: {
                icon: "<i class='fas fa-pizza-slice'>", 
                value: 0, 
                color: '#cfb244'
            }, 
            thirst: {
                icon: "<i class='fas fa-beer'>", 
                value: 0, 
                color: '#44bccf'
            },
        }, 
        accounts: {
            cash: {
                icon: "<i class='fas fa-university'>", 
                value: null, 
                color: '#fff' 
            }, 
            bank: {
                icon: "<i class='fas fa-wallet'>", 
                value: null, 
                color: '#fff' 
            }, 
        },
        jobs: {
            main: {
                icon: "<i class='fas fa-user'>", 
                value: null, 
                color: '#fff' 
            }, 
            secondary: {
                icon: "<i class='fas fa-user-secret'>", 
                value: null, 
                color: '#fff' 
            }, 
        },
        street: {
            main_street: '',
            substreet: ''
        }, 
        speedometer: {
            speed: 0,
            gear: 1,
            fuel: 90,
            geartext: "Gear",
            speedunit: ""
        }, 
        config: {
            inVehicle: false, 
            paused: false,
            logo: null
        }
    },
    mounted() {
        window.addEventListener('message', (event) => {
            /* Accounts */
            this.accounts.cash.value = event.data.money
            this.accounts.bank.value = event.data.bank

            /* Street */ 
            this.street.main_street = event.data.main_street
            this.street.substreet = event.data.substreet

            /* Config */
            this.config.inVehicle = event.data.vehicle
            this.config.paused = event.data.pause 
            this.config.logo = event.data.logo

            /* Speedometer */
            this.speedometer.speed = event.data.speed
            this.speedometer.speedunit = event.data.speedunit
            this.speedometer.geartext = event.data.gear_text
            this.speedometer.gear = event.data.gear
            this.speedometer.fuel = event.data.fuel

            /* Jobs */
            this.jobs.main.value = event.data.job
            this.jobs.secondary.value = event.data.job2

            /* Positions */
            if(this.config.inVehicle){
                $('#status').animate({left: "21.6%"}, 500);
                $('#vehicleFuel').css("width", this.speedometer.fuel + "%")
            } else {
                $('#status').animate({left: "6%"}, 500); 
            }
 
            /* Status */            
            this.status.hunger.value = event.data.hunger
            this.status.thirst.value = event.data.thirst
            this.status.health.value = (event.data.health - 100)
            this.status.stamina.value = event.data.stamina
            this.status.armour.value = event.data.armour
            this.status.stress.value = event.data.stress
        })
    }
})