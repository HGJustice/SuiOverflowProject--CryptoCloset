module backend::ListingContract {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::object_table::{Self, ObjectTable};
    use sui::event;

    struct Listing has key, store {
        id: UID,
        picture: Url,
        owner: address,
        description: String, 
        category: String, 
        brand: String,
        condition: String,
        price: u64,
    }

    // struct ListingHub has key, store {
    //     id: UID,
    //     owner: address,
    //     counter: u64,
    //     listings: ObjectTable<u64, Listing>
    // }

    // fun init(_ctx: &mut TxContext){
    //     transfer::share_object(
    //         ListingHub{
    //             id: object::new(_ctx),
    //             owner: tx_context::sender(_ctx),
    //             counter: 0,
    //             listings: object_table::new(_ctx),
    //         }
    //     )
    // }


}