program fel;
integer v1, v2;

  function f1():integer;
  integer f1v1, f1v2;

    function f1a(integer p1, p2;):integer;
    integer f1av1;
    begin
      f1a := (p1 + p2)*f1av1 + f1v2*v2;
    end;

  begin
    f1 := f1a(p1, f1v2)*v2;
  end;

  function f2(integer p1;):integer;
  integer f2v2;
    
    function f2a(integer par1;):integer;
    integer f2av2;
    begin
      f2av2 := f2a(44)*v2;
    end;

    function f2b():integer;
    integer f2bv1;
    begin
      f2bv1 := f2v2;
    end;

  begin
    f2v2 := f1a(55, 56)+f2b()*p1;
  end;

begin
  v1 := v2*f1();
end.

