module backend::UserManagment {

    use std::string::{Self, String};
    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::object_table::{Self, ObjectTable};
    use sui::event;


    struct User has key, store {
        id: UID, 
        firstName: String,
        lastName: String,
        dob: u64,
        phoneNumber: u64,
        email: String, 
        userName: String,
        userAddress: address,
        isActive: bool,
    }

    struct UserHub has key {
        id: UID, 
        owner: address,
        counter: u64,
        users: ObjectTable<u64, User>
    }

    struct UserCreated has copy, drop {
        id: ID,
        userName: String,
        userAddress: address,
    }

    fun init(_ctx: &mut TxContext){
        transfer::share_object(
            UserHub {
                id: object::new(_ctx),
                owner: tx_context::sender(_ctx),
                counter: 0,
                users: object_table::new(_ctx),
            }
        )
    }

    public entry fun create_user(firstname: vector<u8>, lastname: vector<u8>, 
    dob: u64,phonenumber: u64, email: vector<u8>, username: vector<u8>, userhub: &mut UserHub, _ctx: &mut TxContext){
        userhub.counter = userhub.counter + 1;
        let id = object::new(_ctx);
        
        event::emit(
            UserCreated {
                id: object::uid_to_inner(&id),
                userName: string::utf8(username),
                userAddress: tx_context::sender(_ctx),
            }
        );

        let newUser = User{
            id: id,
            firstName: string::utf8(firstname),
            lastName: string::utf8(lastname),
            dob: dob,
            phoneNumber: phonenumber,
            email: string::utf8(email),
            userName: string::utf8(username),
            userAddress: tx_context::sender(_ctx),
            isActive: true,
        };

        object_table::add(&mut userhub.users, userhub.counter, newUser);


    }

}