module godestnft::main {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct Godestnft has key, store {
        id:UID,
        name: string::String,
        description: string::String,
        url_img: Url,
    }

    struct NFTMinted has copy, drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }

    public fun name(nft: &Godestnft): &string::String {
        &nft.name
    }
    public fun description(nft: &Godestnft): &string::String {
        &name.description
    }
     public fun url_img(nft: &Godestnft): &string::String {
        &name.url_img
    }

    public fun mint_to_sender (
        name: vector<u8>,
        description: vector<u8>,
        url_img: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = Godestnft {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url_img: url::new_unsafe_from_bytes(url_img),

        };

    event::emit(NFTMinted {
        object_id: object::id(&nft),
        creator: sender,
        name: nft.name,
    });

    transfer::public_transfer(nft, sender);
    
    }
    public fun transfer(
        nft: Godestnft, recipient: address, _: &mut TxContext
    ){
        transfer::public_transfer(nft, recipient)
    }

    public fun update_description(
        nft: &mut Godestnft,
        new_description: vector<u8>,
        _: &mut TxContext
    ){
        nft.description = string::utf8(new_description)
    }

    public fun burn(nft: Godestnft, _: &mut TxContext){
        let Godestnft {id, name: _, description: _, url:_} = nft
        object::delete(id)
    }

}