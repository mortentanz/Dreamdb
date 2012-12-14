#region Source file version
// $Archive: /CLR.root/CLR/Text/TextRecordFieldCollection.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: TextRecordFieldCollection.cs $
// $Modtime: 9/11/06 14:25 $
#endregion
        
using System;
using System.Collections.ObjectModel;
using System.Collections.Generic;

namespace Dreamdb.ETL.Text
{
  /// <summary>
  /// Provides access to the collection of field meta data for a TextRecord format. This class cannot be instantiated.
  /// </summary>
  public class TextRecordFieldCollection : KeyedCollection<string, TextRecordField>
  {

    internal TextRecordFieldCollection()
      : base() {}

    internal TextRecordFieldCollection(TextRecordFormat format)
      : base()
    {
      if (format.HasHeader)
      {
        foreach (string name in format.GetHeaderFieldNames())
        {
          if (name != "0")
          {
            Add(name, true);
          }
        }
      }
      foreach (string name in format.GetRecordFieldNames())
      {
        {
          if (name != "0")
          {
            Add(name);
          }
        }
      }
    }

    /// <summary>
    /// Add a text record field to the collection.
    /// </summary>
    /// <param name="name">The name of the text record field (required).</param>
    /// <exception cref="ArgumentNullException">Thrown if the name is null.</exception>
    /// <exception cref="ArgumentException">Thrown if the name is empty or an existing field with the specified name exists.</exception>
    public void Add(string name)
    {
      TextRecordField f = new TextRecordField(name);
      Add(f);
    }

    public void Add(string name, bool isheaderfield)
    {
      TextRecordField f = new TextRecordField(name, isheaderfield);
      Add(f);
    }

    /// <summary>
    /// Gets the zero-based ordinal index of a text field.
    /// </summary>
    /// <param name="name">The name of the field for which to </param>
    /// <returns>The zero-based ordinal position of the field with the specified name.</returns>
    public int IndexOf(string name)
    {
      return Items.IndexOf(this[name]);
    }

    /// <summary>
    /// Defines the name property of the collected fields as the key for the collection.
    /// </summary>
    /// <param name="item">The text record field for which the key is to be extracted.</param>
    /// <returns>The name of the field.</returns>
    protected override string GetKeyForItem(TextRecordField item)
    {
      return item.Name;
    }

  }
}
