require_relative 'spec_helper'
describe GameWindow do
  let(:gw) { GameWindow.instance }
  
  context "Handling objects" do
    let(:obja) { GameObject.new }
    let(:objb) { GameObject.new }

    before do 
      gw.add_object(obja, {input: false, collision: true})
      gw.add_object(objb, {collision: false, input: true})
      gw.update
    end

    after do
      gw.all_objects.each_key { |k| gw.remove_object_by_id(k) }
    end

    context "#Add_Object" do
      it "Registers the object to appropriate lists based on the input hash" do
        expect(gw.all_objects.size).to eq(2)
        expect(gw.object_list[:collision].size).to eq(1)
        expect(gw.object_list[:input].size).to eq(1)
        expect(gw.object_list[:physics].size).to eq(0)
      end
    end

    context "#Remove_Object" do
      it "Removes objects from all relevant lists" do
        gw.remove_object_by_id(obja.id)
        gw.update
        expect(gw.all_objects.size).to eq(1)
        expect(gw.object_list[:collision].size).to eq(0)
        expect(gw.object_list[:input].size).to eq(1)
        expect(gw.object_list[:physics].size).to eq(0)
      end
    end

    context "#Change_Object" do
      it "Moves objects from old lists to new lists" do
        gw.change_object_by_id(obja.id, {collision: false, input: true, visible: true})
        gw.update
        expect(gw.all_objects.size).to eq(2)
        expect(gw.object_list[:collision].size).to eq(0)
        expect(gw.object_list[:input].size).to eq(2)
        expect(gw.object_list[:visible].size).to eq(1)
      end
    end

    context "#Update" do
      it "Runs update on all objects" do 
        expect(obja).to receive(:update)
        expect(objb).to receive(:update)
        gw.update
      end
    end
  end  
  
  context "#Input" do
    let(:input_obj1){ GameObject.new }
    let(:input_obj2){ GameObject.new }
    let(:obj3){ GameObject.new }

    it "Maps input from hardware enums to game buttons" do
      gw.button_down(Gosu::Gp0Button0)
      expect(gw.game_input[:p1a][:is]).to be_true  
      expect(gw.game_input[:p1a][:was]).to be_false
      
      gw.button_up(Gosu::Gp0Button0)
      expect(gw.game_input[:p1a][:is]).to be_false  
      expect(gw.game_input[:p1a][:was]).to be_true
    end

    it "Forwards input to objects registered to Input" do
      expect(input_obj1).to receive(:input).with :p1left
      expect(input_obj2).to receive(:input).with :p1left
      expect(obj3).to_not receive(:input)
     
      gw.add_object(input_obj1, {input: true})
      gw.add_object(input_obj2, {input: true})
      gw.add_object(obj3, nil)
     
      gw.update

      gw.button_down(Gosu::Gp0Left)
    end
  end

  context "#Collision" do
    let(:coll_obj1){ GameObject.new }
    let(:coll_obj2){ GameObject.new }
    let(:obj3){ GameObject.new }

    it "compares all collidable objects" do
      expect(coll_obj1).to receive(:collision).with coll_obj2
      expect(coll_obj2).to receive(:collision).with coll_obj1
      expect(obj3).to_not receive(:collision) 

      gw.add_object(coll_obj1, {collision: true} )
      gw.add_object(coll_obj2, {collision: true} )
      gw.add_object(obj3, nil )

      gw.update

      gw.collision
    end
  end

  context "#Draw" do
    let(:vis_obj1){ GameObject.new }
    let(:vis_obj2){ GameObject.new }
    let(:invis_obj){ GameObject.new }
    
    it "only draws visible objects" do
      expect(vis_obj1).to receive(:draw)
      expect(vis_obj2).to receive(:draw)
      expect(invis_obj).to_not receive(:draw)

      gw.add_object(vis_obj1, {visible: true})
      gw.add_object(vis_obj2, {visible: true})
      gw.add_object(invis_obj, nil)
      
      gw.update

      gw.draw
    end
  end

end
