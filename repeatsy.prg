program ok1;
integer b, c;
integer x;

begin
   read(b, c);
   x := (b + c) - (b - c);
   repeat begin
      x := (b - c);
      read(c, b);
      write(c);
   end until (b = c);
      read(c);
      x := b < c;
   while (x > 0) do begin
      if (b = c) then
          write(b);
      else
          write(c);
      x := x - 1;
   end
end.

