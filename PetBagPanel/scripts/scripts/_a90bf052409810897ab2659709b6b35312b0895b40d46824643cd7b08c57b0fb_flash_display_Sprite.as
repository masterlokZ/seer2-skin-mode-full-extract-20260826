package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   public class _a90bf052409810897ab2659709b6b35312b0895b40d46824643cd7b08c57b0fb_flash_display_Sprite extends Sprite
   {
      
      public function _a90bf052409810897ab2659709b6b35312b0895b40d46824643cd7b08c57b0fb_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

