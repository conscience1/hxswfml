#ifndef INCLUDED_Reflect
#define INCLUDED_Reflect

#include <hxObject.h>

DECLARE_CLASS0(Reflect)


class Reflect_obj : public virtual hxObject
{
	public:
		typedef hxObject super;
		typedef Reflect_obj OBJ_;

	protected:
		Reflect_obj();
		Void __construct();

	public:
		static hxObjectPtr<Reflect_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(DynamicArray inArgs);
		~Reflect_obj();

		DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark();
		String __ToString() const { return STRING(L"Reflect",7); }

		static bool hasField( Dynamic o,String field);
		static Dynamic hasField_dyn();

		static Dynamic field( Dynamic o,String field);
		static Dynamic field_dyn();

		static Void setField( Dynamic o,String field,Dynamic value);
		static Dynamic setField_dyn();

		static Dynamic callMethod( Dynamic o,Dynamic func,Array<Dynamic > args);
		static Dynamic callMethod_dyn();

		static Array<String > fields( Dynamic o);
		static Dynamic fields_dyn();

		static bool isFunction( Dynamic f);
		static Dynamic isFunction_dyn();

		static int compare( Dynamic a,Dynamic b);
		static Dynamic compare_dyn();

		static bool compareMethods( Dynamic f1,Dynamic f2);
		static Dynamic compareMethods_dyn();

		static bool isObject( Dynamic v);
		static Dynamic isObject_dyn();

		static bool deleteField( Dynamic o,String f);
		static Dynamic deleteField_dyn();

		static Dynamic copy( Dynamic o);
		static Dynamic copy_dyn();

		static Dynamic makeVarArgs( Dynamic f);
		static Dynamic makeVarArgs_dyn();

};


#endif /* INCLUDED_Reflect */ 