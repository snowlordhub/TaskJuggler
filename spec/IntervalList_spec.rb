require 'rubygems'
require 'IntervalList'

class TaskJuggler

  describe IntervalList do

    before(:all) do
      @t0 = TjTime.new('2011-01-01').freeze
      @t1 = TjTime.new('2011-01-02').freeze
      @t2 = TjTime.new('2011-01-03').freeze
      @t3 = TjTime.new('2011-01-04').freeze
      @t4 = TjTime.new('2011-01-05').freeze
      @t5 = TjTime.new('2011-01-06').freeze
      @t6 = TjTime.new('2011-01-07').freeze
      @i0_1 = Interval.new(@t0, @t1).freeze
      @i0_2 = Interval.new(@t0, @t2).freeze
      @i0_3 = Interval.new(@t0, @t3).freeze
      @i1_2 = Interval.new(@t1, @t2).freeze
      @i1_3 = Interval.new(@t1, @t3).freeze
      @i2_3 = Interval.new(@t2, @t3).freeze
      @i3_4 = Interval.new(@t3, @t4).freeze
      @i3_6 = Interval.new(@t3, @t6).freeze
      @i4_5 = Interval.new(@t4, @t5).freeze
      @i4_6 = Interval.new(@t4, @t6).freeze
      @i5_6 = Interval.new(@t5, @t6).freeze
    end

    describe "#<<" do

      before do
        @il = IntervalList.new
      end

      it 'should add a new interval' do
        @il << @i0_1
        @il.should == [ @i0_1 ]
      end

      it 'should merge adjecent intervals on add' do
        @il << @i0_1
        @il << @i1_2
        @il.should == [ @i0_2 ]
      end

      it 'should not merge non-adjecent intervals on add' do
        @il << @i0_1
        @il << @i2_3
        @il.should == [ @i0_1, @i2_3 ]
      end

    end

    describe '#&' do

      it 'without overlap should be empty' do
        il1 = IntervalList.new([ @i0_1 ])
        il2 = IntervalList.new([ @i1_2 ])
        (il1 & il2).should be_empty
        (il2 & il1).should be_empty
      end

      it 'with empty list should be empty' do
        il1 = IntervalList.new([ @i0_1 ])
        il2 = IntervalList.new([ ])
        (il1 & il2).should be_empty
        (il2 & il1).should be_empty
      end

      it 'with self should be self' do
        il = IntervalList.new([ @i0_1 ])
        (il & il).should == il
      end

      it 'with partial overlap should be overlap' do
        il1 = IntervalList.new([ @i0_2 ])
        il2 = IntervalList.new([ @i1_3 ])
        il3 = IntervalList.new([ @i1_2 ])
        (il1 & il2).should == il3
        (il2 & il1).should == il3
      end

      it 'with center inclusion should be inclusion' do
        il1 = IntervalList.new([ @i0_3, @i3_6 ])
        il2 = IntervalList.new([ @i1_2, @i4_5 ])
        (il1 & il2).should == il2
        (il2 & il1).should == il2
      end

      it 'with left inclusion should be inclusion' do
        il1 = IntervalList.new([ @i1_3, @i4_6 ])
        il2 = IntervalList.new([ @i1_2, @i4_5 ])
        (il1 & il2).should == il2
        (il2 & il1).should == il2
      end

      it 'with right inclusion should be inclusion' do
        il1 = IntervalList.new([ @i1_3, @i4_6 ])
        il2 = IntervalList.new([ @i2_3, @i5_6 ])
        (il1 & il2).should == il2
        (il2 & il1).should == il2
      end

      it 'with adjecent intervals should be empty' do
        il1 = IntervalList.new([ @i0_1, @i2_3 ])
        il2 = IntervalList.new([ @i1_2, @i3_4 ])
        (il1 & il2).should be_empty
        (il2 & il1).should be_empty
      end

    end

  end

end
