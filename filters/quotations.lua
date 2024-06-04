function capitalize (str)
   return pandoc.Str('[' .. pandoc.text.upper(pandoc.text.sub(str.text, 1, 1))
                     .. ']' .. pandoc.text.sub(str.text, 2))
end

function lowercase (str)
   -- return pandoc.Str(pandoc.text.lower(str.text))
   return pandoc.Str('[' .. pandoc.text.lower(pandoc.text.sub(str.text, 1, 1))
                     .. ']' .. pandoc.text.sub(str.text, 2))
   
end

function Span (el)
   if el.classes:includes('ellipsis') then
      -- return '[…]'    -- return just a Str, all classes and attributes of the Span are lost
      el.content = '[…]' -- keep the Span, just replace the content
      return el
   end

   if el.classes:includes('elision') then
      return {}
   end
   
   if el.classes:includes('cap') then
      local done = false
      
      return el.content:walk {
         Str = function (s)
            if not done then
               done = true
               return capitalize(s)
            end
         end
      }
   end

   if el.classes:includes('lc') then
      local done = false
      
      return el.content:walk {
         Str = function (s)
            if not done then
               done = true
               return lowercase(s)
            end
         end
      }
   end

   if el.classes:includes('sic') then
      el.content:extend({' [', pandoc.Emph('sic'), ']' })
      return el
   end

   if el.classes:includes('add') then
      el.content:insert(1, '[')
      el.content:insert(']')
      return el
   end

   if el.classes:includes('corr') and el.attributes.repl then
      parsed = pandoc.read(el.attributes.repl, 'markdown')
      
      -- local new = pandoc.Inlines { '[' }
      -- new:extend(parsed.blocks[1].content)
      -- new:extend({ ']' })
      
      -- return new

      el.content = parsed.blocks[1].content
      el.content:insert(1, '[')
      el.content:extend({ ']' })
      return el
   end
   
   return nil
end
