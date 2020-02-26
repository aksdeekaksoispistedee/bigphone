using System;
using System.Collections.Generic;
using System.Text;

namespace BeerMonastery
{
    class ActivityQuery
    {
        public int serverFunction;
        public int userID;
        public int rows;

        public override string ToString()
        {
            return this.serverFunction.ToString() + this.userID.ToString() + this.rows.ToString();
        }
    }
}
